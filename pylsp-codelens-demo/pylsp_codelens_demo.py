"""
Install it into the same venv/environment pylsp itself runs from (this matters — plugins register via entry points at import time, so they must live in pylsp's own Python environment):
    ```sh
    cd ~/.local/share/nvim/mason/packages/python-lsp-server/
    . venv/bin/activate
    pip install -e /path/to/pylsp-codelens-demo
    ```
"""  # noqa: D205, D212, D400, D415

import ast
import subprocess

from pylsp import hookimpl


@hookimpl
def pylsp_code_lens(config, workspace, document):
    lenses = []
    try:
        tree = ast.parse(document.source)
    except SyntaxError:
        return lenses

    for node in ast.walk(tree):
        if isinstance(node, ast.FunctionDef) and node.name.startswith('test_'):
            lenses.append(
                {
                    'range': {
                        'start': {'line': node.lineno - 1, 'character': node.col_offset},
                        'end': {'line': node.lineno - 1, 'character': node.col_offset + len(node.name)},
                    },
                    'command': {
                        'title': '▶ Run test',
                        'command': 'pylsp_codelens_demo.runTest',
                        'arguments': [document.path, node.name],
                    },
                },
            )
    return lenses


@hookimpl
def pylsp_commands(config, workspace):
    return ['pylsp_codelens_demo.runTest']


@hookimpl
def pylsp_execute_command(config, workspace, command, arguments):
    if command != 'pylsp_codelens_demo.runTest':
        return
    path, test_name = arguments
    result = subprocess.run(
        ['python', '-m', 'pytest', path, '-k', test_name, '-q'],
        capture_output=True,
        text=True,
    )
    workspace.show_message(result.stdout or result.stderr)
    return
