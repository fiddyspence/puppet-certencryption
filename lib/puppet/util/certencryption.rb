require 'base64'

module Puppet
  module Util
    class Certencryption

      def encrypt(cert, file)
        checkkey(cert)

        encryptkey = loadkey(cert)

        ciphertext=''
        open(file) do |plaintext|
          until plaintext.eof?
            ciphertext+= Base64.encode64(encryptkey.public_encrypt(plaintext.read(500))).gsub("\n",'')+"\n"
          end
        end
        return ciphertext
      end

      def decrypt(cert,file)
        checkkey(cert)

        decryptkey = loadkey(cert)

        plaintext=''
        open(file) do |ciphertext|
          until ciphertext.eof?
            plaintext+= decryptkey.private_decrypt(Base64.decode64(ciphertext.readline))
          end
        end
        return plaintext
      end
 
      def encryptstring(cert,data)
        checkkey(cert)
        encryptkey = loadkey(cert)
        raise Puppet::Error, "No encryption key loaded" unless encryptkey
        ciphertext=''
        data.scan(/.{0,500}/).each do |chunk|
          ciphertext += Base64.encode64(encryptkey.public_encrypt(chunk)).gsub("\n",'')+"\n" if chunk
        end
        return ciphertext
      end

      def decryptstring(cert,data)
        checkkey(cert)
        decryptkey = loadkey(cert)
        raise Puppet::Error, "No encryption key loaded" unless decryptkey
        plaintext=''
        data.split(/\n/).each do |line|
          plaintext += decryptkey.private_decrypt(Base64.decode64(line)) if line
        end
        return plaintext
      end

      private

      def checkkey(cert)
        unless File.exists?(cert)
          raise Puppet::Error, "Could not find public key #{cert}"
        end
      end

      def loadkey(cert)
        begin
          encryptkey = OpenSSL::PKey::RSA.new File.read cert
        rescue OpenSSL::PKey::RSAError
          raise Puppet::Error, "Could not load private key"
        end
        return encryptkey
      end

    end
  end
end
