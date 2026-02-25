<script lang="ts">
	import ciso from '$lib/assets/ciso.svg';
	import { onMount } from 'svelte';

	interface Props {
		height?: number;
		width?: number;
	}

	let { height = 200, width = 200 }: Props = $props();
	let logoSrc = $state(ciso);

	onMount(async () => {
		try {
			const response = await fetch('/api/settings/general/logo/');
			if (response.ok) {
				const blob = await response.blob();
				logoSrc = URL.createObjectURL(blob);
			}
		} catch {
			// mantém logo padrão
		}
	});
</script>

<img class="c" {height} {width} src={logoSrc} alt="Ciso-assistant icon" data-testid="logo-image" />
