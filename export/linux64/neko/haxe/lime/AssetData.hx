package lime;


import lime.utils.Assets;


class AssetData {

	private static var initialized:Bool = false;
	
	public static var library = new #if haxe3 Map <String, #else Hash <#end LibraryType> ();
	public static var path = new #if haxe3 Map <String, #else Hash <#end String> ();
	public static var type = new #if haxe3 Map <String, #else Hash <#end AssetType> ();	
	
	public static function initialize():Void {
		
		if (!initialized) {
			
			path.set ("assets/enemies.png", "assets/enemies.png");
			type.set ("assets/enemies.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/boom.png", "assets/boom.png");
			type.set ("assets/boom.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/svg/enemy.svg", "assets/svg/enemy.svg");
			type.set ("assets/svg/enemy.svg", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/svg/SSG.svg", "assets/svg/SSG.svg");
			type.set ("assets/svg/SSG.svg", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/svg/boom.svg", "assets/svg/boom.svg");
			type.set ("assets/svg/boom.svg", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/ssg.png", "assets/ssg.png");
			type.set ("assets/ssg.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/sounds/flixel.ogg", "assets/sounds/flixel.ogg");
			type.set ("assets/sounds/flixel.ogg", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/sounds/beep.ogg", "assets/sounds/beep.ogg");
			type.set ("assets/sounds/beep.ogg", Reflect.field (AssetType, "sound".toUpperCase ()));
			
			
			initialized = true;
			
		} //!initialized
		
	} //initialize
	
	
} //AssetData
