defmodule BertToJson.MixProject do
  use Mix.Project

  def project do
    [
      app: :bert_to_json,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [main_module: BertToJson],
      releases: [
        {:cli,
         [
           steps: [:assemble, &Bakeware.assemble/1]
         ]},
        burrito_cli: [
          steps: [:assemble, &Burrito.wrap/1],
          burrito: [
            targets: [
              windows: [os: :windows, cpu: :x86_64]
            ]
          ]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {BertToJson, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.4"},
      {:bakeware, "~> 0.2.4", runtime: false},
      {:burrito, github: "burrito-elixir/burrito"}
    ]
  end
end
