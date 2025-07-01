-- split I/O part, for the easiness of testing the logic that doesn't involve I/O handling
-- allow us to test on add, delete, mark done/undone


local todo_app = {}


local todo_app = {}


local filename = "todo.txt"
-- file format done_status|time_stamp|task

function todo_app.check_file()
    local file = io.open("todo.txt", "r")
    if not file then
        file = io.open(filename, "w")
        file:close()
    else
        file:close()
    end
end

function todo_app.load_tasks()
    local tasks = {}
    local file = io.open(filename, "r")
    for line in file:lines() do
        local done, timestamp, text = line:match("(%d)%|([^|]+)%|(.*)") -- number | anything except "|" | task
        table.insert(tasks, {done = done == "1", timestamp = timestamp, text = text})
    end
    file:close()
    return tasks
end

function todo_app.get_new_task_info()
    io.write("Enter task: ")
    local text = io.read()
    local timestamp = os.date("%Y-%m-%d %H:%M")
    return {done = false, timestamp = timestamp, text = text}
end

function todo_app.add_task(tasks, task)
    table.insert(tasks, task)
end


function todo_app.list_tasks(tasks)
    if #tasks == 0 then
        print("No tasks yet.")
        return
    end
    for i, task in ipairs(tasks) do
        local mark = task.done and "[x]" or "[ ]"
        print(i .. ". " .. mark .. " [" .. task.timestamp .. "] " .. task.text)
    end
end

function todo_app.get_task_idx(prompt)
    io.write(prompt)
    local idx = tonumber(io.read())
    return idx
end

function todo_app.mark_done(tasks, idx, verbose)
    if tasks[idx] then
        tasks[idx].done = true
        if verbose then print("Task marked as done.")  end
        return true
    else
        if verbose then print("Invalid task number.") end
        return false
    end
end

function todo_app.mark_undone(tasks, idx, verbose)
    if tasks[idx] then
        tasks[idx].done = false
        if verbose then print("Task marked as done.")  end
        return true
    else
        if verbose then print("Invalid task number.") end
        return false
    end
end

function todo_app.delete_task(tasks, idx, verbose)
    if tasks[idx] then
        table.remove(tasks, idx)
        if verbose then print("Task deleted.") end
        return true
    else
        if verbose then print("Invalid task number.") end
        return false
    end
end

-- update txt file after every action
function todo_app.save_tasks(tasks)
    local file = io.open(filename, "w")
    for _, task in ipairs(tasks) do
        file:write((task.done and "1" or "0") .. "|" .. task.timestamp .. "|" .. task.text .. "\n") -- short-circuit logic
    end
    file:close()
end

function todo_app.run()
    todo_app.check_file()
    local tasks = todo_app.load_tasks()

    while true do
        print("\n--- To-Do List ---")
        print("1. Add task")
        print("2. List tasks")
        print("3. Mark task as done")
        print("4. Mark task as undone")
        print("5. Delete task")
        print("6. Quit")
        io.write("Choose an option: ")

        local choice = io.read()
        if choice == "1" then
            local new_task = todo_app.get_new_task_info()
            todo_app.add_task(tasks, new_task)
            todo_app.save_tasks(tasks)
            print("Task added")
        elseif choice == "2" then
            todo_app.list_tasks(tasks)
        elseif choice == "3" then
            local idx = todo_app.get_task_idx("Task number to mark as done: ")
            todo_app.mark_done(tasks, idx, true)
            todo_app.save_tasks(tasks)
        elseif choice == "4" then
            local idx = todo_app.get_task_idx("Task number to mark as undone: ")
            todo_app.mark_undone(tasks, idx, true)
            todo_app.save_tasks(tasks)
        elseif choice == "5" then
            local idx = todo_app.get_task_idx("Task number to delete: ")
            todo_app.delete_task(tasks, idx, true)
            todo_app.save_tasks(tasks)
        elseif choice == "6" then
            print("Goodbye!")
            break
        else
            print("Invalid option.")
        end
    end
end

return todo_app