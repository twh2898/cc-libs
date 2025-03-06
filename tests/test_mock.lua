local test = {}

function test.no_return()
    local mock = MagicMock()
    expect_eq(nil, mock())
end

function test.return_value()
    local mock = MagicMock()
    mock.return_value = 1
    expect_eq(1, mock())
    expect_eq(1, mock())
end

function test.return_sequence()
    local mock = MagicMock()
    mock.return_sequence = { 1, 2 }
    expect_eq(1, mock())
    expect_eq(2, mock())
    expect_eq(2, mock())
end

function test.return_value_priority()
    local mock = MagicMock()
    mock.return_value = 1
    mock.return_sequence = { 2, 3 }
    expect_eq(1, mock())
    expect_eq(1, mock())
end

function test.call_count()
    local mock = MagicMock()
    expect_eq(0, mock.call_count)
    mock()
    expect_eq(1, mock.call_count)
    mock()
    expect_eq(2, mock.call_count)
end

function test.args()
    local mock = MagicMock()
    assert_true(type(mock.args) == 'table')
    expect_eq(0, #mock.args)
    mock(1, '2')
    expect_eq(1, mock.args[1])
    expect_eq('2', mock.args[2])
    mock('3', 4)
    expect_eq('3', mock.args[1])
    expect_eq(4, mock.args[2])
    mock()
    expect_eq(0, #mock.args)
end

function test.calls()
    local mock = MagicMock()
    mock()
    mock(1)
    mock(2, 3)
    mock('4')
    mock()

    assert_eq(5, #mock.calls)

    expect_eq(0, #mock.calls[1])

    expect_eq(1, #mock.calls[2])
    expect_eq(1, mock.calls[2][1])

    expect_eq(2, #mock.calls[3])
    expect_eq(2, mock.calls[3][1])
    expect_eq(3, mock.calls[3][2])

    expect_eq(1, #mock.calls[4])
    expect_eq('4', mock.calls[4][1])

    expect_eq(0, #mock.calls[5])
end

function test.reset()
    local mock1 = MagicMock()
    local mock2 = MagicMock()
    mock1()
    mock2()
    mock1.reset()
    expect_eq(0, mock1.call_count)
    expect_eq(0, #mock1.args)
    expect_eq(0, #mock1.calls)

    expect_eq(1, mock2.call_count)
end

function test.reset_nested()
    local mock1 = MagicMock()
    mock1.mock2()
    mock1.reset()
    expect_eq(0, mock1.call_count)
    expect_eq(0, #mock1.args)
    expect_eq(0, #mock1.calls)

    expect_eq(1, mock1.mock2.call_count)
end

function test.reset_all()
    local mock1 = MagicMock()
    local mock2 = MagicMock()
    mock1()
    mock2()
    mock1.reset_all()
    expect_eq(0, mock1.call_count)
    expect_eq(0, #mock1.args)
    expect_eq(0, #mock1.calls)

    expect_eq(0, mock2.call_count)
    expect_eq(0, #mock2.args)
    expect_eq(0, #mock2.calls)
end

function test.reset_returns()
    local mock1 = MagicMock()
    local mock2 = MagicMock()
    mock1.return_value = 1
    mock2.return_sequence = { 2, 3 }
    mock1.reset_all()
    expect_eq(nil, mock1.return_value)
    expect_eq(nil, mock1.return_sequence)
    expect_eq(nil, mock2.return_value)
    expect_eq(nil, mock2.return_sequence)
end

return test
