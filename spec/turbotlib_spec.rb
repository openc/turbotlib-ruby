require 'turbotlib'
require 'fileutils'

require "simplecov"
require "coveralls"
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter "spec"
end

describe Turbotlib do
  describe "log" do
    it "should print message" do
      expect {
        Turbotlib.log("hi")
      }.to output("hi\n").to_stderr
    end
  end

  describe "data_dir" do
    context "when developing" do
      after do
        FileUtils.rm_rf("data")
      end

      it "should return data" do
        expect(Turbotlib.data_dir).to eq("data")
      end

      it "should create data directory" do
        Turbotlib.data_dir
        expect(File.exists?("data")).to eq(true)
      end
    end

    context "when running in morph" do
      before do
        allow(ENV).to receive(:[]).with("MORPH_URL").and_return("something")
      end

      it "should return /data" do
        expect(Turbotlib.data_dir).to eq("/data")
      end

      it "should not create data directory" do
        expect(File.exists?("data")).to eq(false)
      end
    end
  end

  describe "sources_dir" do
    context "when developing" do
      after do
        FileUtils.rm_rf("sources")
      end

      it "should return sources" do
        expect(Turbotlib.sources_dir).to eq("sources")
      end

      it "should create sources directory" do
        Turbotlib.sources_dir
        expect(File.exists?("sources")).to eq(true)
      end
    end

    context "when running in morph" do
      context "and not an admin" do
        before do
          allow(Turbotlib).to receive(:in_production?).and_return(true)
        end

        it "should raise exception" do
          expect{Turbotlib.sources_dir}.to raise_error
        end
      end

      context "and an admin" do
        before do
          allow(Turbotlib).to receive(:in_production?).and_return(true)
          allow(Turbotlib).to receive(:is_admin?).and_return(true)
        end

        it "should return /sources" do
          expect(Turbotlib.sources_dir).to eq("/sources")
        end
      end
    end
  end
end
