require 'spec_helper'

describe 'logstash' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "logstash class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('logstash') }
          it { is_expected.to contain_class('logstash::params') }
          it { is_expected.to contain_class('logstash::install') }

          it { is_expected.to contain_file('/etc/systemd/system/logstash@.service') }
          it { is_expected.to contain_package('logstash').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'logstash class without any parameters on an unknown OS' do
      let(:facts) do
        {
          :osfamily        => 'Unknown',
          :operatingsystem => 'UnknownOS',
        }
      end

      it { expect { is_expected.to contain_package('logstash') }.to raise_error(Puppet::Error, /UnknownOS not supported/) }
    end
  end
end
