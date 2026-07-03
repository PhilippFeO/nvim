"""Open this file with pylsp attached — you should see „▶ Run test“ as virtual text above test_addition (styled via the LspCodeLens highlight group), but nothing above helper since it doesn't match the test_ filter. Put the cursor on that line and hit <leader>cl — it runs `pytest -k test_addition` and reports the result via workspace.show_message (surfaces in Neovim as a message from the server)."""


def test_addition():
    assert 1 + 1 == 2


def helper():
    pass
