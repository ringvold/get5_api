defmodule Get5Api.Encryption do
  @moduledoc """
  This module is used for encrypting password before storing it in the database.
  """

  @aad "AES256GCM"

  @doc """
  Generates a random base64 encoded secret key.
  """
  def generate_secret() do
    :crypto.strong_rand_bytes(16)
    |> :base64.encode()
  end

  @doc """
  encrypts the given string of text with the given secret key
  """
  def encrypt(val, key) do
    iv = :crypto.strong_rand_bytes(16)

    {ciphertext, tag} =
      :crypto.crypto_one_time_aead(:aes_gcm, decode_key(key), iv, to_string(val), @aad, 16, true)

    (iv <> tag <> ciphertext)
    |> :base64.encode()
  end

  @doc """
  decrypts the given string of text with the given secret key
  """
  def decrypt(ciphertext, key) do
    ciphertext = :base64.decode(ciphertext)
    <<iv::binary-16, tag::binary-16, ciphertext::binary>> = ciphertext
    :crypto.crypto_one_time_aead(:aes_gcm, decode_key(key), iv, ciphertext, @aad, tag, false)
  end

  def decode_key(key) do
    :base64.decode(key)
  end
end
