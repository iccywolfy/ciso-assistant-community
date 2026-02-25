<script lang="ts">
	import ModelForm from '$lib/components/Forms/ModelForm.svelte';
	import { GeneralSettingsSchema } from '$lib/utils/schemas';
	import { m } from '$paraglide/messages';
	import { page } from '$app/state';
	import { enhance } from '$app/forms';

	let { data } = $props();

	let logoPreview = $state<string | null>(null);

	function onFileChange(event: Event) {
		const file = (event.target as HTMLInputElement).files?.[0];
		if (file) logoPreview = URL.createObjectURL(file);
	}
</script>

<div>
	<span class="text-gray-500 block mb-6">{m.generalSettingsDescription()}</span>
	<ModelForm
		form={data.generalSettingForm}
		schema={GeneralSettingsSchema}
		model={data.generalSettingModel}
		cancelButton={false}
		action="/settings?/general"
	/>

	{#if page.data.user.is_admin}
		<div class="mt-8 border-t pt-6">
			<h3 class="text-lg font-semibold mb-2">Logo da Aplicação</h3>
			<p class="text-gray-500 text-sm mb-4">
				Substitua o logo padrão. Formatos aceitos: PNG, JPEG, SVG, WebP. Máximo: 2MB.
			</p>

			<form
				method="POST"
				action="?/uploadLogo"
				enctype="multipart/form-data"
				use:enhance
				class="flex flex-col gap-3"
			>
				<input
					type="file"
					name="logo"
					accept="image/png,image/jpeg,image/svg+xml,image/webp"
					onchange={onFileChange}
					class="input"
				/>
				{#if logoPreview}
					<img src={logoPreview} alt="Preview" class="h-20 object-contain border rounded p-2" />
				{/if}
				<button type="submit" class="btn preset-filled-primary-500">
					<i class="fa-solid fa-upload mr-2"></i>Aplicar Logo
				</button>
			</form>

			<form method="POST" action="?/deleteLogo" use:enhance class="mt-3">
				<button type="submit" class="btn preset-outlined-error-500">
					<i class="fa-solid fa-trash mr-2"></i>Restaurar Logo Padrão
				</button>
			</form>
		</div>
	{/if}
</div>
