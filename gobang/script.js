const boardSize = 15;
let board = [];
let currentPlayer = 'black';
let gameOver = false;

const boardElement = document.getElementById('board');
const statusElement = document.getElementById('status');
const restartButton = document.getElementById('restart');
const placeSound = document.getElementById('place-sound');
const winSound = document.getElementById('win-sound');

// 检查音效加载
placeSound.addEventListener('error', () => {
  console.warn('无法加载落子音效');
  placeSound.remove();
});

winSound.addEventListener('error', () => {
  console.warn('无法加载胜利音效');
  winSound.remove();
});

// 检查音效是否加载成功
let soundEnabled = true;
placeSound.addEventListener('error', () => {
  console.warn('无法加载落子音效');
  soundEnabled = false;
});
winSound.addEventListener('error', () => {
  console.warn('无法加载胜利音效');
  soundEnabled = false;
});

// 初始化棋盘
function initBoard() {
  board = Array.from({ length: boardSize }, () => 
    Array.from({ length: boardSize }, () => null)
  );
  
  boardElement.innerHTML = '';
  for (let i = 0; i < boardSize; i++) {
    for (let j = 0; j < boardSize; j++) {
      const cell = document.createElement('div');
      cell.classList.add('cell');
      cell.dataset.row = i;
      cell.dataset.col = j;
      cell.addEventListener('click', handleCellClick);
      boardElement.appendChild(cell);
    }
  }
  updateStatus();
}

// 处理点击事件
function handleCellClick(event) {
  if (gameOver) return;
  
  const row = parseInt(event.target.dataset.row);
  const col = parseInt(event.target.dataset.col);
  
  if (board[row][col] !== null) return;
  
  board[row][col] = currentPlayer;
  event.target.classList.add(currentPlayer);
  
  if (soundEnabled) {
    placeSound.currentTime = 0;
    placeSound.play();
  }

  if (checkWin(row, col)) {
    gameOver = true;
    if (soundEnabled) {
      winSound.currentTime = 0;
      winSound.play();
    }
    
    const gameOverDiv = document.createElement('div');
    gameOverDiv.className = 'game-over';
    gameOverDiv.textContent = `${currentPlayer === 'black' ? '黑' : '白'}方获胜！`;
    document.querySelector('.container').appendChild(gameOverDiv);
    return;
  }
  
  currentPlayer = currentPlayer === 'black' ? 'white' : 'black';
  updateStatus();
}

// 检查是否五子连珠
function checkWin(row, col) {
  const directions = [
    [1, 0],  // 垂直
    [0, 1],  // 水平
    [1, 1],  // 对角线
    [1, -1]  // 反对角线
  ];
  
  for (const [dx, dy] of directions) {
    let count = 1;
    
    // 正向检查
    let x = row + dx;
    let y = col + dy;
    while (x >= 0 && x < boardSize && y >= 0 && y < boardSize && 
           board[x][y] === currentPlayer) {
      count++;
      x += dx;
      y += dy;
    }
    
    // 反向检查
    x = row - dx;
    y = col - dy;
    while (x >= 0 && x < boardSize && y >= 0 && y < boardSize && 
           board[x][y] === currentPlayer) {
      count++;
      x -= dx;
      y -= dy;
    }
    
    if (count >= 5) return true;
  }
  
  return false;
}

// 更新状态显示
function updateStatus() {
  statusElement.textContent = `当前轮到：${currentPlayer === 'black' ? '黑' : '白'}方`;
}

// 重新开始游戏
restartButton.addEventListener('click', () => {
  initBoard();
  currentPlayer = 'black';
  gameOver = false;
  updateStatus();
  
  // 移除游戏结束提示
  const gameOverDiv = document.querySelector('.game-over');
  if (gameOverDiv) {
    gameOverDiv.remove();
  }
});

// 初始化游戏
initBoard();
