defmodule Genqr do
  @moduledoc """
  Documentation for Genqr.
  """

  def gen(csv_path, value_index, output_path) do
    csv_path
    |> File.stream!()
    |> CSV.decode()
    |> Enum.each(fn
      {:ok, data} ->
        spawn(fn ->
          qr_code_value =
            data
            |> Enum.at(value_index)

          file_name = "#{output_path}/#{qr_code_value}.png"

          if File.exists?(file_name) do
            :ok
          else
            qr_code_png =
              qr_code_value
              |> EQRCode.encode()
              |> EQRCode.png()

            File.write(file_name, qr_code_png, [:binary])
          end
        end)

      {:error, err} ->
        :error
    end)
  end
end
