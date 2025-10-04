const formularios = [
    document.getElementById('form-docentes-obtener-ci'),
    document.getElementById('form-docentes-obtener-id'),
    document.getElementById('form-docentes-obtener-nombre'),
];

formularios.forEach(form =>
{
    form.addEventListener('submit', async (event) =>
    {
        event.preventDefault();

        const formData = new FormData(form);

        const response = await fetch('../../back/profesores/obtener.php', {
            method: 'POST',
            body: formData
        });
        const result = await response.json();

        if (result.success) {
            Swal.fire({
                icon: 'success',
                title: 'Docente btenido',
                text: 'El docente ha sido obtenido exitosamente: ' + JSON.stringify(result.valor)
            });
            form.reset();
        } else {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: result.mensaje || 'Hubo un error al obtener el docente.'
            });
        }
    })
});