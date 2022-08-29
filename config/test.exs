import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ether, EtherWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "8BCqw2XguUKu8nWnRieolvV4mHJ7Xluor2vcRRZdyZpIojHhkkngFFqb2PCuxlEi",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
