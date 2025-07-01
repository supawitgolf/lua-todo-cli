package.path = "../?.lua;" .. package.path

local todo_app = require "todo_app_v2"

local function unit_test(fn)
    local status, err = pcall(fn)
    if not status then
      print(err)
    end
end

local mock_tasks = {
    {done = false, timestamp = '2025-06-25 00:00', text = 'test1'},
    {done = true, timestamp = '2025-06-26 00:00', text = 'test2'},
}



unit_test(function ()
    local mock_new_task = {done = false, timestamp = '2025-06-27 00:00', text = 'test3'}
    todo_app.add_task(mock_tasks, mock_new_task)

    assert(#mock_tasks == 3, 'todo_app.add_task error: tasks table size')
    -- check if last component is the latest task
    assert(mock_tasks[#mock_tasks].done == false, 'todo_app.add_task error: added task (done)')
    assert(mock_tasks[#mock_tasks].timestamp == '2025-06-27 00:00', 'todo_app.add_task error: added task (timestamp)')
    assert(mock_tasks[#mock_tasks].text == 'test3', 'todo_app.add_task error: added task (text)')
    print('todo_app.add_task passed')
end)

unit_test(function ()
    -- case exist
    local stt = todo_app.mark_done(mock_tasks, 1)
    assert(stt == true, 'todo_app.mark_done error: index mishandling')
    assert(mock_tasks[1].done == true, 'todo_app.mark_done error: done_status')
    -- case inexist
    local stt = todo_app.mark_done(mock_tasks, 4)
    assert(stt == false, 'todo_app.mark_done error: inexisting index mishandling')
    print('todo_app.mark_done passed')
end)

unit_test(function ()
    -- case exist
    local stt = todo_app.mark_undone(mock_tasks, 2)
    assert(stt == true, 'todo_app.mark_undone error: index mishandling')
    assert(mock_tasks[2].done == false, 'todo_app.mark_undone error: done_status')
    -- case inexist
    local stt = todo_app.mark_undone(mock_tasks, 4)
    assert(stt == false, 'todo_app.mark_undone error: inexisting index mishandling')
    print('todo_app.mark_undone passed')
end)

unit_test(function ()
    -- case inexist
    local stt = todo_app.delete_task(mock_tasks, 4)
    assert(stt == false, 'todo_app.delete_task error: inexisting index mishandling')
    -- case exist
    local stt = todo_app.delete_task(mock_tasks, 2)
    assert(stt == true, 'todo_app.delete_task error: index mishandling')
    assert(#mock_tasks == 2, 'todo_app.delete_task error: tasks table size after deletion')
    assert(mock_tasks[#mock_tasks].done == false, 'todo_app.delete_task error: tasks inconsistent (done)')
    assert(mock_tasks[#mock_tasks].timestamp == '2025-06-27 00:00', 'todo_app.delete_task error: tasks inconsistent (timestamp)')
    assert(mock_tasks[#mock_tasks].text == 'test3', 'todo_app.delete_task error: tasks inconsistent (text)')

    -- case inexist
    local stt = todo_app.delete_task(mock_tasks, 3)
    assert(stt == false, 'todo_app.delete_task error: inexisting index mishandling')
    print('todo_app.delete_task passed')
    
end)