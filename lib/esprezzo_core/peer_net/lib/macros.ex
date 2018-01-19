defmodule EsprezzoCore.PeerNet.Macros do
  @moduledoc"""
    # macros useful for peer networks
  """
 
  defmacro __using__(_) do
    quote do
      import EsprezzoCore.PeerNet.Macros
  
      def ip_for_process(pid) do
        :inet.peername(pid)
      end
      
    end

  end

end
