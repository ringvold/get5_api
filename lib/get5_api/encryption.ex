defmodule Get5Api.Encryption do
  @moduledoc """
  This module is used for encrypting password before storing it in the database.
  """

  @aad "AES256GCM"
  @cipher :aes_256_gcm
  @nonce_size 12
  @tag_size 16

  @doc """
  Generates a random base64 encoded secret key.
  """
  def generate_secret() do
    :crypto.strong_rand_bytes(32)
    |> :base64.encode()
  end

  @doc """
  encrypts the given string of text with the given secret key
  """
  def encrypt(val, key \\ find_key()) do
    iv = :crypto.strong_rand_bytes(@nonce_size)

    {ciphertext, tag} =
      :crypto.crypto_one_time_aead(@cipher, decode_key(key), iv, to_string(val), @aad, @tag_size, true)

    (iv <> tag <> ciphertext)
    |> :base64.encode()
  end

  def decrypt(nil = _ciphertext), do: ""

  @doc """
  decrypts the given string of text with the given secret key
  """
  def decrypt(ciphertext, key \\ find_key()) do
    ciphertext = :base64.decode(ciphertext)
    <<iv::binary-12, tag::binary-16, ciphertext::binary>> = ciphertext
    :crypto.crypto_one_time_aead(@cipher, decode_key(key), iv, ciphertext, @aad, tag, false)
  end

  def decode_key(key) do
    :base64.decode(key)
  end

  defp find_key() do
    <<key::binary-size(32), _::bitstring>> = Application.fetch_env!(:get5_api, :encryption_key)
    :base64.encode(key)
  end
end
