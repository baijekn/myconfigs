return {
  -- Настраиваем встроенную в LazyVim тему токио-найт
  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = {
      transparent = true, -- Включаем полную прозрачность
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
}
