<template>
	<view class="content"><button type="default" @click="openFlutter">打开Flutter</button></view>
</template>

<script>
export default {
	data() {
		return {
			title: 'Hello flutter=='
		};
	},
	onLoad() {},
	methods: {
		openFlutter() {
			const flutter = uni.requireNativePlugin('sn-flutter');
			flutter.openFlutter();
		}
	}
};
</script>

<style>
.content {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
}

.logo {
	height: 200rpx;
	width: 200rpx;
	margin-top: 200rpx;
	margin-left: auto;
	margin-right: auto;
	margin-bottom: 50rpx;
}

.text-area {
	display: flex;
	justify-content: center;
}

.title {
	font-size: 36rpx;
	color: #8f8f94;
}
</style>
