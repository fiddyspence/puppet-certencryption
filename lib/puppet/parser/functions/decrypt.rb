module Puppet::Parser::Functions

  newfunction(:decrypt, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
      Wait.

    ENDHEREDOC
    require 'puppet/util/certencryption'
    require 'base64'
    raise Puppet::ParseError, ("decrypt(): Wrong number of arguments (#{args.length}; must be = 2)") unless args.length == 2

    unless (args[0].is_a?(String))
      raise Puppet::ParseError, ("decrypt(): please pass a string, or an array of strings - what you passed didn't work for me at all - #{args[0].class}")
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
