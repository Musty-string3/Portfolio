class Relation < ApplicationRecord
  #class_name: "User"でUserモデルを参照する
  belongs_to :follow, class_name: "User"
  belongs_to :followed, class_name: "User"
end
