import sys
import asyncio

import pytest

import quart_shell_ipython


class TestEventLoopPolicy:
    """Test custom event loop policy."""

    def test_shell_event_loop_policy_returns_loop(self):
        """Test custom event loop policy returns correct loop."""
        loop = asyncio.new_event_loop()

        class ShellEventLoopPolicy(asyncio.DefaultEventLoopPolicy):
            def get_event_loop(self):
                return loop

        policy = ShellEventLoopPolicy()
        assert policy.get_event_loop() == loop
        loop.close()


class TestIntegration:
    """Integration tests for shell command."""

    def test_module_imports(self):
        """Test that module imports correctly."""
        assert hasattr(quart_shell_ipython, 'shell')
        assert callable(quart_shell_ipython.shell)

    def test_shell_is_click_command(self):
        """Test shell is a click command."""
        import click
        assert isinstance(quart_shell_ipython.shell, click.Command)
        assert quart_shell_ipython.shell.name == 'shell'
