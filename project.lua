return {
	DEBUG_MODE = true,
	splashScreen = true,

	-- optimization options
	downsizeImages = false,
	useMP3s = false,

	title = "VS Poyo",
	file = "VSPoyo",
	icon = "art/icon.png",
	version = "2.0",
	package = "com.saxashitter.vspoyo",
	width = 1280,
	height = 720,
	company = "Stilic",

	flags = {
		CheckForUpdates = false,

		InitialAutoFocus = true,
		InitialParallelUpdate = true,
		InitialAsyncInput = false,

		LoxelInitWindow = false,
		LoxelForceRenderCameraComplex = false,
		LoxelDisableRenderCameraComplex = false,
		LoxelDisableScissorOnRenderCameraSimple = false,
		LoxelDefaultClipCamera = true,
		LoxelShowPrintsInScreen = false
	}
}
