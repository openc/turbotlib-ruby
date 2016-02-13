require 'spec_helper'

describe Turbotlib::FTPDelegator do
  T = '\d\d:\d\d:\d\d'

  let :logdev do
    StringIO.new
  end

  let :logger do
    Turbotlib::Logger.new('turbot', 'INFO', logdev)
  end

  let :ftp do
    Turbotlib::FTP.new('echanges.dila.gouv.fr')
  end

  let :delegator do
    Turbotlib::FTPDelegator.new(ftp)
  end

  before do
    # Stub the methods that call `Net::FTP#open_socket`.
    allow_any_instance_of(Net::FTP).to receive(:connect)
    allow_any_instance_of(Net::FTP).to receive(:transfercmd).and_return(double({
      :close => nil,
      :gets => nil,
      :read => nil,
      :read_timeout= => nil,
      :shutdown => nil,
    }))
    # Stub the default socket.
    allow_any_instance_of(Net::FTP::NullSocket).to receive(:write)
    allow_any_instance_of(Net::FTP::NullSocket).to receive(:closed?).and_return(true)
    allow_any_instance_of(Net::FTP::NullSocket).to receive(:readline).and_return('200')
  end

  before(:each) do
    delegator.logger = logger
    delegator.login
  end

  describe '#initialize' do
    it 'succeeds' do
      expect(logdev.string).to match(/\A#{T} INFO turbot: login\n\z/)
    end
  end

  describe '#nlst' do
    it 'logs the command' do
      delegator.nlst
      expect(logdev.string).to match(/\A#{T} INFO turbot: login\n#{T} INFO turbot: nlst\n\z/)
    end

    it 'logs the command and the directory' do
      delegator.nlst('foo')
      expect(logdev.string).to match(/\A#{T} INFO turbot: login\n#{T} INFO turbot: nlst foo\n\z/)
    end
  end

  describe '#chdir' do
    it 'succeeds' do
      delegator.chdir('BODACC')
      expect(logdev.string).to match(/\A#{T} INFO turbot: login\n#{T} INFO turbot: chdir BODACC\n\z/)
    end

    context 'on error' do
      before do
        expect(ftp).to receive(:putline).once.and_raise(Errno::ETIMEDOUT)
      end

      it 'retries' do
        delegator.chdir('BODACC')
        expect(logdev.string).to match(/\A#{T} INFO turbot: login\n#{T} INFO turbot: chdir BODACC\n#{T} ERROR turbot: (?:Connection|Operation) timed out on TYPE I\n#{T} INFO turbot: login\n#{T} INFO turbot: chdir BODACC\n\z/)
      end
    end
  end
end
