const formDocentesRegistrar = document.getElementById('form-docentes-registrar');

formDocentesRegistrar.addEventListener('submit', async (event) => {
    event.preventDefault();

    const formData = new FormData(formDocentesRegistrar);

    const response = await fetch('../../back/profesores/registrar.php', {
        method: 'POST',
        body: formData
    });
    const result = await response.json();

    if (result.success) {
        Swal.fire({
            icon: 'success',
            title: 'Docente registrado',
            text: 'El docente ha sido registrado exitosamente.'
        });
        formDocentesRegistrar.reset();
    } else {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: result.mensaje || 'Hubo un error al registrar el docente.'
        });
    }
});