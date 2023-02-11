{
  const uls = document.querySelectorAll('ul');
  const dropdown = document.querySelector('.dropdown-list');
  uls.forEach(ul => {
    ul.addEventListener('click', () => {
      dropdown.classList.toggle('active');
    });
  });
  document.addEventListener('click', (e) => {
    if(!e.target.closest('.right-menu')) {
      dropdown.classList.remove('active');
    }
  });
}
