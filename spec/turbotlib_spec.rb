require 'turbotlib'

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
      it "should return data/" do
        expect(Turbotlib.data_dir).to eq("data/")
      end
    end

    context "when running in morph" do
      before do
        allow(ENV).to receive(:[]).with("MORPH_URL").and_return("something")
      end

      it "should return /data/" do
        expect(Turbotlib.data_dir).to eq("/data/")
      end
    end
  end
end
