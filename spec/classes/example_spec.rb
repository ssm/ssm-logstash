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

          it { is_expected.to contain_class('logstash::params') }
          it { is_expected.to contain_class('logstash::install').that_comes_before('logstash::config') }
          it { is_expected.to contain_class('logstash::config') }
          it { is_expected.to contain_class('logstash::service').that_subscribes_to('logstash::config') }

          it { is_expected.to contain_service('logstash') }
          it { is_expected.to contain_package('logstash').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'logstash class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('logstash') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
