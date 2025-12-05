#!/bin/bash
# Integration test for quart-shell-ipython

set -e

echo "Creating test app..."
cat > test_app.py <<'PYEOF'
from quart import Quart, g

app = Quart(__name__)

@app.route('/')
async def hello():
    return 'Hello, World!'
PYEOF

echo "Running integration test..."
QUART_APP=test_app:app timeout 5 quart shell <<'EOF' || exit 1
# Test 1: App context (g) availability
from quart import g
g.test_value = 'Hello from g!'
assert g.test_value == 'Hello from g!', 'g does not work'
print('✓ Test 1: App context (g) works')

# Test 2: Event loop availability
import asyncio
loop = asyncio.get_event_loop()
assert loop is not None, 'No event loop'
print('✓ Test 2: Event loop available')

# Test 3: Async code execution
async def test_async():
    await asyncio.sleep(0.01)
    return 'success'

result = await test_async()
assert result == 'success', 'Async code failed'
print('✓ Test 3: Async code works')

print('\n✅ All integration tests passed!')
exit()
EOF

echo "Cleaning up..."
rm -f test_app.py

echo "✅ Integration tests completed successfully"
