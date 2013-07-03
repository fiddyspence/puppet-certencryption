module Puppet::Parser::Functions

  newfunction(:decrypt, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
      A function to decrypt data previously encrypted with fiddyspence/certencryption

      Usage:
      decrypt('/etc/puppetlabs/puppet/ssl/private_keys/thekey.pem',$::theencryptedfact')

    ENDHEREDOC
    require 'puppet/util/certencryption'
    require 'base64'

    raise Puppet::ParseError, ("decrypt(): Wrong number of arguments (#{args.length}; must be = 2)") unless args.length == 2

    unless (File.exists?(args[0]))
      raise Puppet::ParseError, ("decrypt(): The private key #{args[0]} appears not to exist")
    end

    begin
      a=Puppet::Util::Certencryption.new
      retval = a.decryptstring(args[0],Base64.decode64(args[1]))
    rescue => e
      raise Puppet::ParseError, ("decrypt(): sorry: " + e.message )
    end
    retval
  end
end
