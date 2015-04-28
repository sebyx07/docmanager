class DocumentWord
  include Mongoid::Document
  field :value, type: String
  field :documents, type: Array, default: []
end
