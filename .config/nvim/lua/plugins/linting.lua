return {
	"mfussenegger/nvim-lint",
	config = function()
		local lint = require("lint")

		lint.linters.vale = {
			cmd = "vale",
			stdin = true,
			-- Important: Add "--output=line" so vale prints errors in a predictable format.
			-- The '--no-exit' flag prevents vale from exiting with an error code, which nvim-lint can handle more gracefully.
			args = { "--no-config", "--output=line", "--no-exit", "--", "-" },
			-- This parser function is crucial. It tells nvim-lint how to read vale's output.
			parser = function(output)
				local diagnostics = {}
				-- This pattern matches the "filename:line:column:message" format.
				for line in vim.gsplit(output, "\n", { trimempty = true }) do
					local parts = vim.split(line, ":", { plain = true, trimempty = true })
					if #parts >= 4 then
						local severity = vim.diagnostic.severity.HINT -- Default severity
						-- You can map vale's severity levels if needed, e.g., 'error', 'warning'
						-- For simplicity, we'll use HINT for all.

						table.insert(diagnostics, {
							lnum = tonumber(parts[2]),
							col = tonumber(parts[3]),
							message = parts[4],
							severity = severity,
							source = "vale",
						})
					end
				end
				return diagnostics
			end,
		}

		-- Don't forget to assign the linter to the correct filetypes
		lint.linters_by_ft = {
			markdown = { "vale" },
			text = { "vale" },
			-- add any other filetypes you want to lint with vale
		}
	end,
}
