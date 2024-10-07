
-- Mendapatkan informasi dasar dari buffer aktif
local function getBufferInfo()
    return {
        sourcePath = vim.fn.expand('%'),        -- Path lengkap dari file buffer (/path/filename.ext)
        baseName = vim.fn.expand('%:r'),        -- Nama file tanpa ekstensi (/path/filename)
        fileType = vim.fn.expand('%:e'),        -- Ekstensi file (tipe file) (sh, cpp, rs, fish, java, kt)
        fileName = vim.fn.expand('%:t:r'),      -- Nama file dari buffer tanpa ekstensi ( filename)
    }
end

-- Menyusun perintah berdasarkan tipe file
local function buildCommand(bufferInfo)
    local languageCommands = {
        lua = { run = "lua " .. bufferInfo.sourcePath },
        sh = { run = "bash " .. bufferInfo.sourcePath },
        fish = { run = "fish " .. bufferInfo.sourcePath },
        rs = { run = "cd " .. vim.fn.expand('%:h') .. " && cargo run -q", cleanup = " && cargo clean" },
        cpp = {
            compile = string.format("g++ %s -o %s", bufferInfo.sourcePath, bufferInfo.baseName),
            run = string.format("&& ./%s", bufferInfo.baseName),
            cleanup = string.format("&& rm -f %s", bufferInfo.baseName),
        },
        java = {
            compile = string.format("javac %s -d %s", bufferInfo.sourcePath, bufferInfo.baseName),
            run = string.format("&& cd %s && java %s", bufferInfo.baseName, bufferInfo.fileName),
            cleanup = string.format("&& rm -rf %s", bufferInfo.baseName),
        },
        kt = {
            compile = string.format("kotlinc %s -include-runtime -d %s.jar", bufferInfo.sourcePath, bufferInfo.baseName),
            run = string.format("&& java -jar %s.jar", bufferInfo.baseName),
            cleanup = string.format("&& rm -f %s.jar", bufferInfo.baseName),
        },
    }

    local commands = languageCommands[bufferInfo.fileType]
    if not commands then
        print("\n[Err!] This file type is not supported! Only supports: {sh, fish, cpp, rust, java, kotlin}\n")
        return nil
    end

    -- Membangun perintah yang akan dieksekusi
    local commandString = ""
    for _, action in ipairs({"compile", "run", "cleanup"}) do
        if commands[action] then
            commandString = commandString .. commands[action]
        end
    end

    return commandString
end

-- Menjalankan perintah dalam terminal baru
local function executeCommand(commandString)
    if commandString and commandString ~= "" then
        vim.api.nvim_command(":w")  -- Simpan file sebelum menjalankan
        vim.api.nvim_command("split term://" .. commandString) -- Jalankan perintah di terminal baru
    end
end

-- Fungsi utama untuk mengompilasi dan menjalankan kode
local function main()
    local bufferInfo = getBufferInfo()                -- Ambil informasi buffer
    local commandString = buildCommand(bufferInfo)     -- Bangun perintah berdasarkan tipe file
    executeCommand(commandString)                       -- Jalankan perintah
end

function BuffRunner() main() end

-- Daftarkan perintah BuffRun untuk menjalankan fungsi BuffRunner
vim.api.nvim_command("command! -nargs=0 BuffRun lua BuffRunner()")

