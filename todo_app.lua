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

function todo_app.add_task(tasks)
    io.write("Enter task: ")
    local text = io.read()
    local timestamp = os.date("%Y-%m-%d %H:%M")
    table.insert(tasks, {done = false, timestamp = timestamp, text = text})
    print("Task added at " .. timestamp)
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

function todo_app.mark_done(tasks)
    io.write("Task number to mark as done: ")
    local idx = tonumber(io.read())
    if tasks[idx] then
        tasks[idx].done = true
        print("Task marked as done.")
    else
        print("Invalid task number.")
    end
end

function todo_app.mark_undone(tasks)
    io.write("Task number to mark as undone: ")
    local idx = tonumber(io.read())
    if tasks[idx] then
        tasks[idx].done = false
        print("Task marked as undone.")
    else
        print("Invalid task number.")
    end
end

function todo_app.delete_task(tasks)
    io.write("Task number to delete: ")
    local idx = tonumber(io.read())
    if tasks[idx] then
        table.remove(tasks, idx)
        print("Task deleted.")
    else
        print("Invalid task number.")
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
            todo_app.add_task(tasks)
            todo_app.save_tasks(tasks)
        elseif choice == "2" then
            todo_app.list_tasks(tasks)
        elseif choice == "3" then
            todo_app.mark_done(tasks)
            todo_app.save_tasks(tasks)
        elseif choice == "4" then
            todo_app.mark_undone(tasks)
            todo_app.save_tasks(tasks)
        elseif choice == "5" then
            todo_app.delete_task(tasks)
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