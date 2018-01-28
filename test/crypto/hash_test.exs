defmodule EsprezzoCore.HashTest do
  use ExUnit.Case
  alias EsprezzoCore.Crypto.Hash
  
  @input "Some arbitrarily long nonsense string"

  test "correctly encodes md5" do
    assert Hash.md5(@input) == "403928C9B4FBF4869AB556D649AB1948"
  end

  test "correctly encodes sha224" do
    assert Hash.sha224(@input) == "7AF9397DD59804547DB2FFA9ED538E9062A9446652C2D1C0667E6C6E"
  end

  test "correctly encodes sha256" do
    assert Hash.sha256(@input) == "FD09A9E22EA5E1BE241F4D6F5822DB84E9BC1C5EF80C1A5D0BA441A94C3EE9E8"
  end

  test "correctly encodes sha384" do
    assert Hash.sha384(@input) == "4321F4A1B2221A1F2BFA825AEEBDE4221DF48EEAF6DAAF9F41F356EBCD42F7A7BB8D316D53FA3CF2592BF7DF4EDC232D"
  end

  test "correctly encodes sha512" do
    assert Hash.sha512(@input) == "80A0F38D9EE0B2C5D0823EAB26C74D9E852F7E58EDE3893D8691761FC3CC5B24576EBD97AE74E02CB2D3A79E238DF8D0353AEC6F2DF0F55C541946D778E96BE3"
  end

end