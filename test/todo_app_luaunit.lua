package.path = "../?.lua;" .. package.path

local lu = require('luaunit')
local todo_app = require "todo_app_v2"

TestTodo = {}

function TestTodo:testAddition()

    local mock_tasks = {
        {done = false, timestamp = '2025-06-25 00:00', text = 'test1'},
        {done = true, timestamp = '2025-06-26 00:00', text = 'test2'},
    }
    local mock_new_task = {done = false, timestamp = '2025-06-27 00:00', text = 'test3'}

    todo_app.add_task(mock_tasks, mock_new_task)

    lu.assertEquals(#mock_tasks, 3, 'tasks table size')
    lu.assertEquals(mock_tasks[#mock_tasks].done, false, 'added task (done_status)')
    lu.assertEquals(mock_tasks[#mock_tasks].timestamp, '2025-06-27 00:00', 'added task (timestamp)')
    lu.assertEquals(mock_tasks[#mock_tasks].text, 'test3', 'added task (text)')

end

function TestTodo:testMarkDone()

    local mock_tasks = {
        {done = false, timestamp = '2025-06-25 00:00', text = 'test1'},
        {done = true, timestamp = '2025-06-26 00:00', text = 'test2'},
    }

    local stt = todo_app.mark_done(mock_tasks, 1)
    lu.assertEquals(stt, true, 'index mishandling')
    lu.assertEquals(mock_tasks[1].done, true, 'done_status')

    -- case inexist
    local stt = todo_app.mark_done(mock_tasks, -1)
    lu.assertEquals(stt, false, 'inexisting index mishandling')
    local stt = todo_app.mark_done(mock_tasks, 3)
    lu.assertEquals(stt, false, 'inexisting index mishandling')

end


function TestTodo:testMarkUndone()

    local mock_tasks = {
        {done = false, timestamp = '2025-06-25 00:00', text = 'test1'},
        {done = true, timestamp = '2025-06-26 00:00', text = 'test2'},
    }

    local stt = todo_app.mark_undone(mock_tasks, 2)
    lu.assertEquals(stt, true, 'index mishandling')
    lu.assertEquals(mock_tasks[1].done, false, 'done_status')

    local stt = todo_app.mark_undone(mock_tasks, 1)
    lu.assertEquals(stt, true, 'index mishandling')
    lu.assertEquals(mock_tasks[1].done, false, 'done_status')

    -- case inexist
    local stt = todo_app.mark_done(mock_tasks, -1)
    lu.assertEquals(stt, false, 'inexisting index mishandling')
    local stt = todo_app.mark_done(mock_tasks, 3)
    lu.assertEquals(stt, false, 'inexisting index mishandling')

end

function TestTodo:testDeletion()

    local mock_tasks = {
        {done = false, timestamp = '2025-06-25 00:00', text = 'test1'},
        {done = true, timestamp = '2025-06-26 00:00', text = 'test2'},
        {done = false, timestamp = '2025-06-27 00:00', text = 'test3'}
    }

    -- case inexist
    local stt = todo_app.delete_task(mock_tasks, 4)
    lu.assertEquals(stt, false, 'inexisting index mishandling')
    local stt = todo_app.delete_task(mock_tasks, -1)
    lu.assertEquals(stt, false, 'inexisting index mishandling')


    local stt = todo_app.delete_task(mock_tasks, 2)
    lu.assertEquals(stt, true, 'index mishandling')
    lu.assertEquals(#mock_tasks, 2, 'tasks table size after deletion')
    lu.assertEquals(mock_tasks[#mock_tasks].done, false, 'tasks inconsistency (done_status)')
    lu.assertEquals(mock_tasks[#mock_tasks].timestamp, '2025-06-27 00:00',  'tasks inconsistency (timestamp)')
    lu.assertEquals(mock_tasks[#mock_tasks].text, 'test3',  'tasks inconsistency (text)')
   
    -- case inexist
    local stt = todo_app.delete_task(mock_tasks, 3)
    lu.assertEquals(stt, false, 'inexisting index mishandling')

end


os.exit(lu.LuaUnit.run())