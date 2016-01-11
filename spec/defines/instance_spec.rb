require 'spec_helper'

instance = 'test'

describe 'logstash::instance' do
  let(:title) { instance }
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "without parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_logstash__instance(instance) }
          it { is_expected.to contain_service("logstash@#{instance}").with_ensure('running') }
          it { is_expected.to contain_concat("logstash::instance::#{instance}") }
          it { is_expected.to contain_file("/etc/systemd/system/logstash@#{instance}.service") }
        end

        context "ensure => absent" do
          let(:params) do
            { ensure: 'absent' }
          end
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_logstash__instance(instance) }
          it { is_expected.to contain_service("logstash@#{instance}").with_ensure('stopped') }
          it { is_expected.to contain_concat("logstash::instance::#{instance}").with_ensure('absent') }
          it { is_expected.to contain_file("/etc/systemd/system/logstash@#{instance}.service").with_ensure('absent') }
        end
      end
    end
  end
end
