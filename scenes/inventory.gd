extends Control

@onready var item_list: ItemList = $ItemList
var items := []  # menyimpan daftar nama item

func add_item(item_name: String, item_icon: Texture2D):
	items.append(item_name)
	item_list.add_item(item_name,item_icon)
