# .formatter.exs
[
  import_deps: [:phoenix, :ecto, :phoenix_live_view],
  inputs: ["*.{ex,exs}", "{config,lib,test}/**/*.{ex,exs}"],
  plugins: [Phoenix.LiveView.HTMLFormatter]
]
