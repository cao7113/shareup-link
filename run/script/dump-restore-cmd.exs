alias Slink.Repo

%{
  username: username,
  database: dbname,
  hostname: dbhost,
  password: password
} = Repo.config() |> Keyword.take([:username, :password, :hostname, :database]) |> Map.new()

tm = DateTime.utc_now() |> DateTime.truncate(:second) |> DateTime.to_iso8601()

dump_file = "#{dbname}-bak#{tm}.sql"

dump_cmd =
  "PGPASSWORD='#{password}' pg_dump -h #{dbhost} -p 5432 -U #{username} -Fc -b -v -f #{dump_file} -d #{dbname}"

IO.puts("dump command: \n#{dump_cmd}")

target_db = "#{dbname}_bak1"
restore_cmd = "pg_restore -v -h localhost -U postgres -j 2 -d #{target_db} #{dump_file}"
IO.puts("restore command: \n#{restore_cmd}")
