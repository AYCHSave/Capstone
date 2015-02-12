json.array!(@states) do |state|
  json.extract! state, :id
  json.url state_url(state, format: :json)
end
