-- compile and run
function BuffRunner ()
    local get = {
        src = vim.fn.expand('%'),      --path of buffer file
        dest = vim.fn.expand('%:r'),   --path buff without file ekstension
        type = vim.fn.expand('%:e'),   --ekstension only
        name = vim.fn.expand('%:t:r'), --file name of buffer
    }

    local Buffer = {
        --[[ BASH ]]
        sh = {
            run = "/usr/bin/bash " .. get.src
        },
        --[[ FISH ]]
        fish = {
            run = "fish " .. get.src
        },
        --[[ RUSTLANG ]]
        rs = {
            run = 'cd %:h && RUSTFLAGS=\\"-Awarnings\\" cargo run -q',
            -- delTemp = " && sleep 0.1 && cargo clean",
        },
        --[[ C++ ]]
        cpp = {
            compile = string.format("g++ %s -o %s ", get.src, get.dest),
            run = string.format("&& %s ", get.dest),
            delTemp = string.format("&& rm -rf %s", get.dest)
        },
        --[[ JAVA ]]
        java = {
            compile = string.format("javac %s -d %s ", get.src, get.dest),
            run = string.format("&& cd %s && java %s ", get.dest, get.name),
            delTemp = string.format("&& cd $HOME && rm -rf %s", get.dest),
        },
        --[[ KOTLIN ]]
        kt = {
            compile = string.format("kotlinc %s -include-runtime -d %s.jar ", get.src, get.dest),
            run = string.format("&& java -jar %s.jar ", get.dest),
            delTemp = string.format("&& rm -rf %s.jar", get.dest),
        },
    }

    local cmd = ""
    if Buffer[get.type] then
        for _, action in ipairs({ "compile", "run", "delTemp" }) do
            if Buffer[get.type][action] then
                cmd = cmd .. Buffer[get.type][action]
            end
        end
    else
        print("\n[Err!] this file not setup!\n\nonly support for:\n{sh, fish, cpp, rush, java, kotlin}\n")
        return
    end

    if cmd ~= "" then
        -- save file
        vim.api.nvim_command(":w")
        -- compile, run, and delete binary temp
        vim.api.nvim_command("split term://" .. cmd)
    end
end

vim.api.nvim_command("command! -nargs=0 BuffRun lua BuffRunner()")

