# .credo.exs
%{
  configs: [
    %{
      name: "default",
      files: %{
        included: [
          "lib/",
          "src/",
          "test/",
          "web/",
          "apps/*/lib/",
          "apps/*/src/",
          "apps/*/test/",
          "apps/*/web/"
        ],
        excluded: [~r"/_build/", ~r"/deps/", ~r"/node_modules/"]
      },
      requires: [],
      strict: true,
      parse_timeout: 5000,
      color: true,
      checks: %{
        enabled: [
          {Credo.Check.Consistency.ParameterPatternMatching, false},
          {Credo.Check.Design.TagTODO, false},
          {Credo.Check.Design.TagFIXME, false},
          {Credo.Check.Readability.MaxLineLength, [max_length: 120]},
          {Credo.Check.Refactor.LongQuoteBlocks, false},
          {Credo.Check.Refactor.MatchInCondition, false},
          {Credo.Check.Warning.UnusedEnumOperation, false},
          {Credo.Check.Warning.UnusedKeywordOperation, false},
          {Credo.Check.Warning.UnusedListOperation, false},
          {Credo.Check.Warning.UnusedStringOperation, false},
          {Credo.Check.Warning.UnusedTupleOperation, false}
        ],
        disabled: []
      }
    }
  ]
}
