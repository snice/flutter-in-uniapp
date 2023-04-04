<script>
	export default {
		onLaunch: function() {
			uni.$flutter = uni.requireNativePlugin('sn-flutter')
			console.log('App Launch')
		},
		onShow: function() {
			console.log('App Show')
		},
		onHide: function() {
			console.log('App Hide')
		}
	}
</script>

<style>
	/*每个页面公共css */
</style>