require 'spec_helper'

describe Turbotlib do
  describe '.log' do
    it 'prints a message' do
      expect {
        Turbotlib.log('hi')
      }.to output("hi\n").to_stderr
    end
  end

  describe '.data_dir' do
    context 'when developing' do
      after do
        FileUtils.rm_rf('data')
      end

      it 'returns "data" and creates the directory' do
        expect(Turbotlib.data_dir).to eq('data')
        expect(File.exists?('data')).to eq(true)
      end
    end

    context 'when running in morph' do
      before do
        allow(ENV).to receive(:[]).with('MORPH_URL').and_return('something')
      end

      it 'returns "/data" and does not create the directory' do
        expect(Turbotlib.data_dir).to eq('/data')
        expect(File.exists?('data')).to eq(false)
      end
    end
  end

  describe '.sources_dir' do
    context 'when developing' do
      after do
        FileUtils.rm_rf('sources')
      end

      it 'returns "sources" and creates the directory' do
        expect(Turbotlib.sources_dir).to eq('sources')
        expect(File.exists?('sources')).to eq(true)
      end
    end

    context 'when running in morph' do
      before do
        allow(Turbotlib).to receive(:in_production?).and_return(true)
      end

      context 'and not an admin' do
        it 'raises an error' do
          expect{Turbotlib.sources_dir}.to raise_error("Only admins are permitted to write to `sources_dir`")
        end
      end

      context 'and an admin' do
        before do
          allow(Turbotlib).to receive(:is_admin?).and_return(true)
        end

        it 'returns "/sources" and does not create the directory' do
          expect(Turbotlib.sources_dir).to eq('/sources')
          expect(File.exists?('/sources')).to eq(false)
        end
      end
    end
  end

  describe '.save_var' do
    after do
      FileUtils.rm_rf('data')
    end

    it 'saves and returns the variable' do
      expect(Turbotlib.get_var('foo')).to eq(nil)
      expect(Turbotlib.save_var('foo', 'bar')).to eq('bar')
      expect(Turbotlib.get_var('foo')).to eq('bar')
    end
  end
end
