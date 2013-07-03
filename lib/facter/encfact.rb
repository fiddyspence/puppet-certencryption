require 'puppet/util/certencryption'
require 'base64'
Facter.add("encfact") do
  a=Puppet::Util::Certencryption.new
  setcode do
    Base64.encode64(a.encrypt('/etc/puppetlabs/puppet/ssl/public_keys/puppet1.spence.org.uk.local.pem','/etc/passwd'))
  end
end
