require 'spec_helper_acceptance'

describe 'logstash class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      yumrepo { 'logstash':
        descr    => 'logstash repo for centos',
        baseurl  => 'https://packages.elastic.co/logstash/2.1/centos',
        gpgcheck => '1',
        enabled  => '1',
        gpgkey   => 'https://packages.elastic.co/GPG-KEY-elasticsearch',
      }
      class { '::java': distribution => 'jre' }
      class { '::logstash': }
      logstash::instance { 'test01': }

      Class['java'] -> Class['logstash']
      Yumrepo['logstash'] -> Class['logstash']

      logstash::config { 'input':
        instance => 'test01',
        content  => 'input { syslog { port => 10514 } }'
      }
      logstash::config { 'output':
        instance => 'test01',
        content  => 'output { stdout { } }'
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe package('logstash') do
      it { is_expected.to be_installed }
    end

    describe service('logstash@test01') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe file('/etc/logstash/test01.conf') do
      its(:content) { is_expected.to match(/input.*syslog.*10514/) }
      its(:content) { is_expected.to match(/output.*stdout/) }
    end
  end
end
