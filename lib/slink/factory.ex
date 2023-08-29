defmodule Slink.Factory do
  use ExMachina.Ecto, repo: Slink.Repo

  def user_factory do
    %Slink.Accounts.User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      hashed_password: Bcrypt.hash_pwd_salt("test")
    }
  end

  def link_factory do
    %Slink.Links.Link{
      title: Faker.Lorem.sentence(),
      url: Faker.Internet.url()
    }
  end
end
