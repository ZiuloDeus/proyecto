const formDocentesRegistrar = document.getElementById('form-sesion-login');

formDocentesRegistrar.addEventListener('submit', async (event) => {
    event.preventDefault();

    const formData = new FormData(formDocentesRegistrar);

    const response = await fetch('../../back/sesion/login.php', {
        method: 'POST',
        body: formData
    });
    const result = await response.json();

    if (result.success) {
        Swal.fire({
            icon: 'success',
            title: 'Login exitoso',
            text: `${result.valor.usuario['nombre']} ${result.valor.usuario['apellido']}, Has iniciado sesion exitosamente como un ${result.valor.rol}.`
        });
        formDocentesRegistrar.reset();
    } else {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: result.mensaje || 'Hubo un error al iniciar sesion.'
        });
    }
});