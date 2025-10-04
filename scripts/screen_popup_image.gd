class_name ScreenPopupImage extends ScreenPopup

@export
var image: Texture2D:
	set(value):
		$VBoxContainer/Content/TextureRect.texture = value
	get:
		return $VBoxContainer/Content/TextureRect.texture
