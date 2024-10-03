return {
  { "nvim-neotest/neotest-plenary" },
  { "nvim-neotest/neotest-python" },
  {
    "nvim-neotest/neotest",
    opts = { adapters = { "neotest-plenary", "neotest-python", "neotest-rust" } },
  },
}
