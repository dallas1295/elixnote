defmodule Elixnote.Journal do
  @moduledoc """
  Handles entry storage and retrieval 
  """
  @journal_dir "priv/entries"

  def write_entry(content) do
    # 1. Timestamp file
    # 2. Write the file content
    # 3. Return a success or a fail (with messages)
    File.mkdir_p!(@journal_dir)

    filename = timestamped()
    filepath = Path.join(@journal_dir, filename)

    case File.write(filepath, content) do
      :ok -> {:ok, filename}
      {:error, reason} -> {:error, reason}
    end
  end

  def read_entries do
    # 1. List all the files in the journal_dir
    # 2. Read the content from the files
    # 3. Return the list of entries
    case File.ls(@journal_dir) do
      {:ok, files} ->
        files
        |> Enum.filter(&String.ends_with?(&1, ".md"))
        |> Enum.map(&read_entry/1)

      {:error, _reason} ->
        []
    end
  end

  defp read_entry(filename) do
    filepath = Path.join(@journal_dir, filename)

    case File.read(filepath) do
      {:ok, content} -> {filename, content}
      {:error, _reason} -> {filename, "Error reading file"}
    end
  end

  defp timestamped do
    # Example: "entry_2023_12_01.md"
    timestamp = DateTime.utc_now() |> DateTime.to_iso8601() |> String.replace(":", "-")
    "entry_#{timestamp}.md"
  end
end
