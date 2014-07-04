require 'turbotlib'
require 'fileutils'

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
end
