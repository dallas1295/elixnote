defmodule Elixnote.CLI do
  @moduledoc """
  Command-line interface for Elixnote
  """

  def start() do
    show_menu()
  end

  defp show_menu() do
    IO.puts("\n\n === Elixnote ===")
    IO.puts("1. Write a new entry")
    IO.puts("2. Read entries")
    IO.puts("3. Exit")
    IO.write("Choose an option: ")

    case IO.gets("") |> String.trim() do
      "1" ->
        write_entry()

      "2" ->
        read_entries()

      "3" ->
        IO.puts("Bye!")

      _ ->
        IO.puts("Invalid option")
        show_menu()
    end
  end

  defp write_entry() do
    IO.puts("\n === Write new entry ===")
    IO.puts("Enter your journal entry (empty line to finish): ")

    content = read_multiline_input()

    case Elixnote.Journal.write_entry(content) do
      {:ok, filename} ->
        IO.puts("Entry saved as: #{filename}")

      {:error, reason} ->
        IO.puts("Error saving entry: #{reason}")
    end
  end

  defp read_entries() do
    IO.puts("\n=== Journal Entries ===")

    entries = Elixnote.Journal.read_entries()

    if Enum.empty?(entries) do
      IO.puts("No entries found.")
    else
      Enum.each(entries, fn {filename, content} ->
        IO.puts("\n--- #{filename} ---")
        IO.puts(content)
      end)
    end

    show_menu()
  end

  defp read_multiline_input() do
    IO.puts("(Press Enter twice to finish)")
    read_lines([])
  end

  defp read_lines(lines) do
    case IO.gets("") do
      :eof ->
        # End of input (Ctrl+D)
        lines |> Enum.reverse() |> Enum.join("\n")

      line ->
        trimmed = String.trim_trailing(line, "\n")

        if trimmed == "" do
          # Empty line - finish input
          lines |> Enum.reverse() |> Enum.join("\n")
        else
          # Add line and continue
          read_lines([trimmed | lines])
        end
    end
  end
end
